#Область ПрограммныйИнтерфейс

// Начинает фоновое выполнение загрузки операций по Яндекс.Кассе.
//
// Параметры:
//  ПараметрыЗагрузки - Структура - параметры загрузки операций.
//   * Период - СтандартныйПериод, Структура - Период за который будут выбираться операции по Яндекс.Кассе.
//    ** ДатаНачала - Дата - начало периода запроса. 
//                           Если не указан, дата начала будет определена автоматически.
//    ** ДатаОкончания - Дата - окончание периода запроса. 
//                              Если не указан, дата окончания будет равна текущей дате.
//   * Организация - ОпределяемыйТип.Организация - организация, по которой нужно отобрать операции. 
//                                                 Если не указана то, будут обработаны все действительные настройки;
//   * СДоговором - Булево, Неопределено - позволяет указать для каких настроек следует загружать операции:
//    ** Неопределено - будут загружены и операции по схемам "С договором" и "Без договора"
//    ** Истина - будут загружены операции по схеме "С договором"
//    ** Ложь - будут загружены операции по схеме "Без договора"
//    Если указан параметр Организация, этот параметр не учитывается.
//  ОписаниеОповещения - ОписаниеОповещения, Неопределено - описание метода, который должен быть вызван по окончании загрузки.
//
Процедура НачатьЗагрузкуОперацийПоЯндексКассе(ВыводитьОкноОжидания = Ложь) Экспорт
	
	ПараметрыЗагрузки = НовыйПараметрыЗагрузки();
	ПараметрыЗагрузки.ПоказыватьОповещениеПользователя = ВыводитьОкноОжидания;
	
	ДлительнаяОперация = ИнтеграцияСЯндексКассойУНФ.НачатьЗагрузкуОперацийПоЯндексКассе(ПараметрыЗагрузки);
	
	ОповещениеПослеЗагрузки = Новый ОписаниеОповещения("ЗагрузитьОперацииПоЯндексКассеЗавершение", ЭтотОбъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Загрузка операций по Яндекс.Кассе'");
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = ВыводитьОкноОжидания;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеПослеЗагрузки, ПараметрыОжидания);
	
КонецПроцедуры

// Обработчик оповещения завершения загрузки операций по Яндекс.Кассе.
//
// Параметры:
// 	Результат - Структура - Результат выполнения фонового задания.
// 	ДопПараметры - Струкутра - Дополнительные параметры.
//
Процедура ЗагрузитьОперацииПоЯндексКассеЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Неопределено Тогда  // отменено пользователем
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("Сообщения") Тогда 
		Для Каждого Сообщение Из Результат.Сообщения Цикл 
			Сообщение.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		Если Не ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда
			Возврат;
		КонецЕсли;
		
		СчетчикЗагруженныхДокументов = 0;
		СчетчикНезагруженныхДокументов = 0;
		ПоказыватьОповещениеПользователя = Истина;
		
		РезультатЗагрузки = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если РезультатЗагрузки <> Неопределено Тогда
			РезультатЗагрузкиОпераций = РезультатЗагрузки.РезультатЗагрузкиОпераций;
			Для каждого ЭлементРезультата Из РезультатЗагрузкиОпераций Цикл
				СчетчикЗагруженныхДокументов = СчетчикЗагруженныхДокументов + ЭлементРезультата.Значение.КоличествоЗагруженыхОпераций;
				СчетчикНезагруженныхДокументов = СчетчикНезагруженныхДокументов + ЭлементРезультата.Значение.КоличествоНезагруженыхОпераций;
			КонецЦикла;
			ПоказыватьОповещениеПользователя = РезультатЗагрузки.ПоказыватьОповещениеПользователя;
		КонецЕсли;
		
		Если ПоказыватьОповещениеПользователя ИЛИ СчетчикЗагруженныхДокументов > 0 Тогда
			
			ТекстСообщения = ?(СчетчикЗагруженныхДокументов, НСтр("ru = 'Загружено из Яндекс.Кассы: %1'")
			, НСтр("ru = 'Новых операций по Яндекс.Кассе нет'"));
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстСообщения, СчетчикЗагруженныхДокументов);
			
			ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка завершена'"),
				"e1cib/list/Документ.ОперацияПоПлатежнымКартам",
				ТекстСообщения);
				
			Если СчетчикЗагруженныхДокументов Тогда
				Оповестить("ИнтеграцияСЯндексКассой_ЗагруженыДокументы", СчетчикЗагруженныхДокументов);
			КонецЕсли;
				
		КонецЕсли;
		
		Если СчетчикЗагруженныхДокументов Тогда 
			ОповеститьОбИзменении(Тип("ДокументСсылка.ОперацияПоПлатежнымКартам"));
		КонецЕсли;
		
		Если ПоказыватьОповещениеПользователя И СчетчикНезагруженныхДокументов > 0 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не загружено операций по Яндекс.Кассе: %1. Подробности в журнале регистрации.'"),
				СчетчикНезагруженныхДокументов));
		КонецЕсли;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ПодробноеПредставлениеОшибки);
		ПоказатьПредупреждение(,Результат.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует пустую структуру параметров загрузки операций из Яндекс.Кассы.
// См. НачатьЗагрузкуОперацийПоЯндексКассе()
//
Функция НовыйПараметрыЗагрузки() Экспорт
	
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("Период", Неопределено);
	ПараметрыЗагрузки.Вставить("Организация", Неопределено);
	ПараметрыЗагрузки.Вставить("СДоговором", Неопределено);
	ПараметрыЗагрузки.Вставить("ПоказыватьОповещениеПользователя", Истина);
	
	Возврат ПараметрыЗагрузки;
	
КонецФункции

// Обработчик оповещения о загрузке операций из Яндекс.Кассы в формах списков.
//
// Параметры:
// 	Список - ТаблицаФормы - Список, который требуется обновить после загрузки операций.
// 	ИмяСобытия - Строка - Идентификатор события
// 	Параметр - Произвольный - Параметр события
// 	Источник - Произвольный - Источник события
//
Процедура ОбработкаОповещения_ФормаСписка(Список, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ИнтеграцияСЯндексКассой_ЗагруженыДокументы" Тогда
		Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
