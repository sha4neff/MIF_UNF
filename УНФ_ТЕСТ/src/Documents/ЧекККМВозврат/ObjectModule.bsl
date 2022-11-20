#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура заполнения документа на основании расходного кассового ордера.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоЧекуККМ(ДанныеЗаполнения) Экспорт
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("ДокументСсылка.ЧекККМ") Тогда
		
		ВызватьИсключение НСтр("ru = 'Чеки ККМ на возврат должны вводиться на основании чеков ККМ'");
		
	КонецЕсли;
	
	// Заполним данные шапки документа.
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЧекККМ.ВалютаДокумента КАК ВалютаДокумента,
	|	ЧекККМ.Ссылка КАК ЧекККМ,
	|	ЧекККМ.ВидЦен КАК ВидЦен,
	|	ЧекККМ.ВидСкидкиНаценки КАК ВидСкидкиНаценки,
	|	ЧекККМ.Организация КАК Организация,
	|	ЧекККМ.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЧекККМ.КассаККМ КАК КассаККМ,
	|	ЧекККМ.КассоваяСмена КАК КассоваяСмена,
	|	ЧекККМ.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЧекККМ.Ячейка КАК Ячейка,
	|	ЧекККМ.Подразделение КАК Подразделение,
	|	ЧекККМ.Ответственный КАК Ответственный,
	|	ЧекККМ.Организация.ПодписьРуководителя КАК ПодписьРуководителя,
	|	ЧекККМ.ПодписьКассира КАК ПодписьКассира,
	|	ЧекККМ.КонтактноеЛицоПодписант КАК КонтактноеЛицоПодписант,
	|	ЧекККМ.СуммаДокумента КАК СуммаДокумента,
	|	ЧекККМ.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	ЧекККМ.НДСВключатьВСтоимость КАК НДСВключатьВСтоимость,
	|	ЧекККМ.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	ЧекККМ.ДисконтнаяКарта КАК ДисконтнаяКарта,
	|	ЧекККМ.ПроцентСкидкиПоДисконтнойКарте КАК ПроцентСкидкиПоДисконтнойКарте,
	|	ЧекККМ.СпециальныйНалоговыйРежим КАК СпециальныйНалоговыйРежим,
	|	ЧекККМ.Запасы.(
	|		Номенклатура КАК Номенклатура,
	|		Характеристика КАК Характеристика,
	|		Партия КАК Партия,
	|		Количество КАК Количество,
	|		ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		Цена КАК Цена,
	|		ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
	|		СуммаСкидкиНаценки КАК СуммаСкидкиНаценки,
	|		Сумма КАК Сумма,
	|		СтавкаНДС КАК СтавкаНДС,
	|		СуммаНДС КАК СуммаНДС,
	|		Всего КАК Всего,
	|		ПроцентАвтоматическойСкидки КАК ПроцентАвтоматическойСкидки,
	|		СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|		КлючСвязи КАК КлючСвязи,
	|		Заказ КАК Заказ,
	|		СерийныеНомера КАК СерийныеНомера,
	|		НоменклатураНабора КАК НоменклатураНабора,
	|		ХарактеристикаНабора КАК ХарактеристикаНабора,
	|		ДоляСтоимости КАК ДоляСтоимости,
	|		НеобходимостьВводаАкцизнойМарки КАК НеобходимостьВводаАкцизнойМарки,
	|		НоменклатураЕГАИС КАК НоменклатураЕГАИС,
	|		Штрихкод КАК Штрихкод,
	|		СуммаСкидкиОплатыБонусом КАК СуммаСкидкиОплатыБонусом,
	|		КодМаркировки КАК КодМаркировки,
	|		СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		Ячейка КАК Ячейка
	|	) КАК Запасы,
	|	ЧекККМ.ДобавленныеНаборы.(
	|		НоменклатураНабора КАК НоменклатураНабора,
	|		ХарактеристикаНабора КАК ХарактеристикаНабора,
	|		Количество КАК Количество
	|	) КАК ДобавленныеНаборы,
	|	ЧекККМ.БезналичнаяОплата.(
	|		ВидПлатежнойКарты КАК ВидПлатежнойКарты,
	|		НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|		Сумма КАК Сумма,
	|		СсылочныйНомер КАК СсылочныйНомер,
	|		НомерЧекаЭТ КАК НомерЧекаЭТ,
	|		ВидОплаты КАК ВидОплаты,
	|		ПодарочныйСертификат КАК ПодарочныйСертификат,
	|		НомерСертификата КАК НомерСертификата,
	|		ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|		БонуснаяКарта КАК БонуснаяКарта,
	|		СуммаБонусов КАК СуммаБонусов
	|	) КАК БезналичнаяОплата,
	|	ЧекККМ.НомерЧекаККМ КАК НомерЧекаККМ,
	|	ЧекККМ.Проведен КАК Проведен,
	|	ЧекККМ.СкидкиНаценки.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		КлючСвязи КАК КлючСвязи,
	|		СкидкаНаценка КАК СкидкаНаценка,
	|		Сумма КАК Сумма
	|	) КАК СкидкиНаценки,
	|	ЧекККМ.СкидкиРассчитаны КАК СкидкиРассчитаны,
	|	ЧекККМ.АкцизныеМарки.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		КлючСвязи КАК КлючСвязи,
	|		КодАкцизнойМарки КАК КодАкцизнойМарки,
	|		АкцизнаяМарка КАК АкцизнаяМарка,
	|		Справка2 КАК Справка2,
	|		ШтрихкодУпаковки КАК ШтрихкодУпаковки
	|	) КАК АкцизныеМарки,
	|	ЧекККМ.ПоложениеЗаказаПокупателя КАК ПоложениеЗаказаПокупателя,
	|	ЧекККМ.Заказ КАК Заказ,
	|	ЧекККМ.Контрагент КАК Контрагент,
	|	ЧекККМ.БонусныеБаллыКНачислению.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		КлючСвязи КАК КлючСвязи,
	|		СкидкаНаценка КАК СкидкаНаценка,
	|		ДатаНачисления КАК ДатаНачисления,
	|		ДатаСписания КАК ДатаСписания,
	|		КоличествоБонусныхБаллов КАК КоличествоБонусныхБаллов
	|	) КАК БонусныеБаллыКНачислению,
	|	ЧекККМ.Договор КАК Договор,
	|	ЧекККМ.СпособЗачетаПредоплаты КАК СпособЗачетаПредоплаты,
	|	ЧекККМ.Кратность КАК Кратность,
	|	ЧекККМ.Курс КАК Курс,
	|	ЧекККМ.ОперацияСДенежнымиСредствами КАК ОперацияСДенежнымиСредствами,
	|	ЧекККМ.Предоплата.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Документ КАК Документ,
	|		Заказ КАК Заказ,
	|		СуммаРасчетов КАК СуммаРасчетов,
	|		Курс КАК Курс,
	|		Кратность КАК Кратность,
	|		СуммаПлатежа КАК СуммаПлатежа
	|	) КАК Предоплата,
	|	ЧекККМ.ПоложениеСклада КАК ПоложениеСклада
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка, ,"НомерЧекаККМ, Проведен, КассоваяСмена");
	
	ТекстОшибки = "";
	
	Если НЕ Выборка.Проведен Тогда
		
		ТекстОшибки = НСтр("ru='Чек ККМ не проведен. Ввод на основании невозможен'");
		
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Выборка.НомерЧекаККМ) Тогда
		
		ТекстОшибки = НСтр("ru='Чек ККМ не пробит. Ввод на основании невозможен'");
	
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Если РозничныеПродажиСервер.СменаОткрыта(Выборка.КассоваяСмена, ТекущаяДата(), ТекстОшибки) Тогда
		
		КассоваяСмена = Выборка.КассоваяСмена;
		
	Иначе
		
		СостояниеКассовойСмены = РозничныеПродажиСервер.ПолучитьСостояниеКассовойСмены(Выборка.КассаККМ);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеКассовойСмены,, "Ответственный");
		КассоваяСмена = СостояниеКассовойСмены.ОтчетОРозничныхПродажах;
		
	КонецЕсли;
	
	Запасы.Загрузить(Выборка.Запасы.Выгрузить());
	ДобавленныеНаборы.Загрузить(Выборка.ДобавленныеНаборы.Выгрузить());
	БезналичнаяОплата.Загрузить(Выборка.БезналичнаяОплата.Выгрузить());
	БонусныеБаллыКНачислению.Загрузить(Выборка.БонусныеБаллыКНачислению.Выгрузить());
	Предоплата.Загрузить(Выборка.Предоплата.Выгрузить());
	
	УдалитьОдноразовыеСертификаты(БезналичнаяОплата);
	УдалитьОплатуБонусами(БезналичнаяОплата);
	
	РаботаССерийнымиНомерами.ЗаполнитьТЧСерийныеНомераПоКлючуСвязи(ЭтотОбъект, ДанныеЗаполнения);
	
	// АвтоматическиеСкидки
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки") Тогда
		СкидкиНаценки.Загрузить(Выборка.СкидкиНаценки.Выгрузить());
	КонецЕсли;
	// Конец АвтоматическиеСкидки
	
	АкцизныеМарки.Загрузить(Выборка.АкцизныеМарки.Выгрузить());
	
КонецПроцедуры // ЗаполнитьПоРасходномуКассовомуОрдеру()

// Добавляет дополнительные реквизиты, необходимые для проведения документа в
// переданную структуру.
//
// Параметры:
//  СтруктураДополнительныеСвойства - Структура дополнительных свойств документа.
//
Процедура ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения(СтруктураДополнительныеСвойства)
	
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ЧекПробит", ЗначениеЗаполнено(НомерЧекаККМ));
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("Архивный", Архивный);
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ДвиженияПоЗапасамУдалять", ДвиженияПоЗапасамУдалять);
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ОперацияСДенежнымиСредствами", ОперацияСДенежнымиСредствами);
	
КонецПроцедуры // ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения()

Процедура УдалитьОдноразовыеСертификаты(ТабличнаяЧасть)
	
	Для Индекс = 1 - ТабличнаяЧасть.Количество() По 0 Цикл
		Строка = ТабличнаяЧасть.Получить(-Индекс);
		Если Строка.ВидОплаты = Перечисления.ВидыБезналичныхОплат.ПодарочныйСертификат Тогда
			Если ЗначениеЗаполнено(Строка.ПодарочныйСертификат) Тогда
				Если Не Строка.ПодарочныйСертификат.ЧастичноеПогашение Тогда
					ТабличнаяЧасть.Удалить(Строка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьОплатуБонусами(ТабличнаяЧасть)
	
	Для Индекс = 1 - ТабличнаяЧасть.Количество() По 0 Цикл
		Строка = ТабличнаяЧасть.Получить(-Индекс);
		Если Строка.ВидОплаты = Перечисления.ВидыБезналичныхОплат.Бонусы Тогда
			Если ЗначениеЗаполнено(Строка.БонуснаяКарта) Тогда
				РевизитыБонуснойПрограммы = РаботаСБонусами.РеквизитыБонуснойПрограммы(Строка.БонуснаяКарта);
				Если Не РевизитыБонуснойПрограммы.НачислятьБонусыПриВозврате Тогда
					ТабличнаяЧасть.Удалить(Строка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура АссистентУправленияПриСрабатыванииСобытия()
	
	Если Не ДополнительныеСвойства.ДляПроведения.ЧекПробит Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДисконтнаяКарта) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("Начислено", -БонусныеБаллыКНачислению.Итог("КоличествоБонусныхБаллов"));
	ПараметрыСообщения.Вставить("Списано", -БезналичнаяОплата.Итог("СуммаБонусов"));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыСообщения", ПараметрыСообщения);
	
	ЕстьНачисление = ДополнительныеПараметры.ПараметрыСообщения.Начислено <> 0;
	ЕстьСписание = ДополнительныеПараметры.ПараметрыСообщения.Списано <> 0;
	
	Событие = Неопределено;
	Если ЕстьНачисление И ЕстьСписание Тогда
		Событие = "СписаниеНачислениеБонусовПриПродаже";
	ИначеЕсли ЕстьНачисление Тогда
		Событие = "НачислениеБонусовПриПродаже";
	ИначеЕсли ЕстьСписание Тогда
		Событие = "СписаниеБонусовПриПродаже";
	КонецЕсли;
	
	Если Событие = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АссистентУправления.ПриСрабатыванииСобытия(ДисконтнаяКарта, Событие, Ссылка, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события "При копировании".
//
Процедура ПриКопировании(ОбъектКопирования)
	
	ВызватьИсключение НСтр("ru = 'Чек на возврат вводится только на основании'");
	
КонецПроцедуры // ПриКопировании()

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, "ЗаполнитьПоЧекуККМ", "Контрагент");
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события "Обработка проверки заполнения".
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЧекККМ.КассоваяСмена КАК КассоваяСмена,
	|	ЧекККМ.Дата КАК Дата,
	|	ЧекККМ.Проведен КАК Проведен,
	|	ЧекККМ.НомерЧекаККМ КАК НомерЧекаККМ
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &ЧекККМ";
	
	Запрос.УстановитьПараметр("ЧекККМ", ЧекККМ);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ Выборка.Проведен Тогда
			
			ТекстОшибки = НСтр("ru='Чек ККМ не проведен'");
			
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстОшибки,
				Неопределено,
				Неопределено,
				"ЧекККМ",
				Отказ
			); 

		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Выборка.НомерЧекаККМ) Тогда
			
			ТекстОшибки = НСтр("ru='Чек ККМ продажи не пробит'");
			
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстОшибки,
				Неопределено,
				Неопределено,
				"ЧекККМ",
				Отказ
			);
			
		КонецЕсли;
		
		ТекстОшибки = НСтр("ru='Кассовая смена не открыта'");
		Если НЕ РозничныеПродажиСервер.СменаОткрыта(КассоваяСмена, Дата, ТекстОшибки) Тогда
			
			
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстОшибки,
				Неопределено,
				Неопределено,
				"КассоваяСмена",
				Отказ
			);

		КонецЕсли;
		
	КонецЦикла;
	
	// Скидка 100%.
	ЕстьРучныеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиНаценкиПродажи");
	ЕстьАвтоматическиеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки"); // АвтоматическиеСкидки
	Если ЕстьРучныеСкидки ИЛИ ЕстьАвтоматическиеСкидки Тогда
		Для каждого СтрокаЗапасы Из Запасы Цикл
			// АвтоматическиеСкидки
			ТекСумма = СтрокаЗапасы.Цена * СтрокаЗапасы.Количество;
			ТекСуммаРучнойСкидки = ?(ЕстьРучныеСкидки, СтрокаЗапасы.СуммаСкидкиНаценки, 0);
			ТекСуммаАвтоматическойСкидки = ?(ЕстьАвтоматическиеСкидки, СтрокаЗапасы.СуммаАвтоматическойСкидки, 0);
			ТекСуммаСкидки = ТекСуммаРучнойСкидки + ТекСуммаАвтоматическойСкидки;
			Если СтрокаЗапасы.ПроцентСкидкиНаценки <> 100 И ТекСуммаСкидки < ТекСумма
				И НЕ ЗначениеЗаполнено(СтрокаЗапасы.Сумма) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнена колонка ""Сумма"" в строке %Номер% списка ""Запасы"".'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", СтрокаЗапасы.НомерСтроки);
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					ТекстСообщения,
					"Запасы",
					СтрокаЗапасы.НомерСтроки,
					"Сумма",
					Отказ
				);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Серийные номера
	РаботаССерийнымиНомерами.ПроверкаЗаполненияСерийныхНомеров(Отказ, Запасы, СерийныеНомера, СтруктурнаяЕдиница, ЭтотОбъект);
	
	// Наборы
	НаборыСервер.ПроверитьТабличнуюЧасть(ЭтотОбъект, "Запасы", Отказ);
	// КонецНаборы
	
	// ПодарочныеCертификаты
	Если Константы.ФункциональнаяОпцияИспользоватьПодарочныеСертификаты.Получить() Тогда
		
		Если Не РаботаСПодарочнымиСертификатами.УказанКонтрагентДляПредоплаты() Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнена константа ""Служебный контрагент для подарочных сертификатов"". Необходимо указать контрагента: Продажи - Еще больше возможностей.'");
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				,,,
				Отказ
			);
		КонецЕсли;
		
	КонецЕсли;
	
	РаботаСПодарочнымиСертификатами.ПроверитьСрокДействия(ЭтотОбъект, "Запасы", Отказ);
	// Конец ПодарочыеСертификаты
	
	// Контроль сумм в табличных частях
	Если ОперацияСДенежнымиСредствами Тогда
		СуммаДляКонтроля = СуммаДокумента;
	Иначе
		СуммаДляКонтроля = Запасы.Итог("Всего");
	КонецЕсли;
	Если СуммаДляКонтроля < БезналичнаяОплата.Итог("Сумма") Тогда
		ТекстСообщения = НСтр("ru = 'Сумма безналичной оплаты больше суммы документа.'");
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			ТекстСообщения,
			,,,
			Отказ
		);
	КонецЕсли;
	// Конец Контроль сумм в табличных частях
	
	// Бонусы
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммы") Тогда
		Если Не БезналичнаяОплата.Найти(Перечисления.ВидыБезналичныхОплат.Бонусы, "ВидОплаты") = Неопределено Тогда
			
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("БезналичнаяОплата.Сумма"));
			
			Для Каждого СтрокаОплаты Из БезналичнаяОплата Цикл
				
				Если СтрокаОплаты.ВидОплаты = Перечисления.ВидыБезналичныхОплат.Бонусы Тогда
					Если Не ЗначениеЗаполнено(СтрокаОплаты.СуммаБонусов) Тогда
						
						ТекстСообщения = НСтр("ru = 'В строке №%1 не указана сумма оплаты.'");
						ТекстСообщения = СтрШаблон(ТекстСообщения, СтрокаОплаты.НомерСтроки);
						УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
							ЭтотОбъект,
							ТекстСообщения,
							"БезналичнаяОплата",
							СтрокаОплаты.НомерСтроки,
							"СуммаБонусов",
							Отказ
						);
						
					КонецЕсли;
				Иначе
					Если Не ЗначениеЗаполнено(СтрокаОплаты.Сумма) Тогда
						
						ТекстСообщения = НСтр("ru = 'В строке №%1 не указана сумма оплаты.'");
						ТекстСообщения = СтрШаблон(ТекстСообщения, СтрокаОплаты.НомерСтроки);
						УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
							ЭтотОбъект,
							ТекстСообщения,
							"БезналичнаяОплата",
							СтрокаОплаты.НомерСтроки,
							"Сумма",
							Отказ
						);
						
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	// Конец Бонусы
	
	Если Не ОперацияСДенежнымиСредствами Тогда
		Если Предоплата.Количество() = 0 Тогда
			УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Курс");
			УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кратность");
		КонецЕсли;
	КонецЕсли;
	
	// ИнтеграцияГосИС
	Если ИнтеграцияИСМПВызовСервера.ВестиУчетМаркируемойПродукции(Перечисления.ВидыПродукцииИС.Обувь) Тогда
		ИнтеграцияИСУНФ.ПроверитьЗаполнениеАкцизныхМарок(ЭтотОбъект, Отказ);
	КонецЕсли;
	// Конец ИнтеграцияГосИС
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерЧекаККМ)
	   И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
	   И НЕ КассаККМ.ИспользоватьБезПодключенияОборудования Тогда
		
		Отказ = Истина;
		
		ТекстОшибки = НСтр("ru='Чек ККМ на возврат пробит на фискальном регистраторе. Отмена проведения невозможна'");
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект);
			
		Возврат;
		
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
	   И КассаККМ.ИспользоватьБезПодключенияОборудования
	   И КассоваяСмена.Проведен
	   И КассоваяСмена.СтатусКассовойСмены = Перечисления.СтатусыОтчетаОРозничныхПродажах.Закрыта Тогда
		
		ТекстСообщения = НСтр("ru='Кассовая смена закрыта. Отмена проведения невозможна'");
		
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				,
				,
				,
				Отказ
			);
		
		Возврат;
		
	КонецЕсли;
	
	// Заказы покупателей в розничной торговле
	Если ПоложениеЗаказаПокупателя <> Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
		ЕстьЗаказы = НЕ Заказ.Пустая();
		Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
			СтрокаТабличнойЧасти.Заказ = ?(ЗначениеЗаполнено(Заказ), Заказ, Неопределено);
		КонецЦикла;
	Иначе
		ЕстьЗаказы = Ложь;
		Заказ = ЗаполнениеОбъектовУНФ.ЗначениеДляШапки(Запасы, "Заказ");
	КонецЕсли;
	
	Если НЕ ЕстьЗаказы Тогда
		Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
			Если НЕ СтрокаТабличнойЧасти.Заказ.Пустая() Тогда
				ЕстьЗаказы = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	// Конец Заказы покупателей в розничной торговле
	
	// Заполнение безналичной оплаты для старых документов
	Если БезналичнаяОплата.Количество() > 0 Тогда
		РаботаСПодарочнымиСертификатами.ПроверитьЗаполнитьБезналичнуюОплатуДокумента(ЭтотОбъект);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	// До включения автоматических скидок будем считать, что скидки рассчитаны.
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки") Тогда
		СкидкиРассчитаны = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	// Взаиморасчеты
	РасчетыПроведениеДокументов.ИнициализироватьДополнительныеСвойстваДляПроведения(ЭтотОбъект, ДополнительныеСвойства, Отказ, Ложь);
	
	ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ЧекККМВозврат.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	УправлениеНебольшойФирмойСервер.ОтразитьЗапасы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДенежныеСредстваВКассахККМ(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыКассовыйМетод(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыНераспределенные(ДополнительныеСвойства, Движения, Отказ);
	
	УправлениеНебольшойФирмойСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	
	// ДисконтныеКарты
	УправлениеНебольшойФирмойСервер.ОтразитьПродажиПоДисконтнойКарте(ДополнительныеСвойства, Движения, Отказ);
	// АвтоматическиеСкидки
	УправлениеНебольшойФирмойСервер.ОтразитьПредоставленныеСкидки(ДополнительныеСвойства, Движения, Отказ);
	// Эквайринг
	УправлениеНебольшойФирмойСервер.ОтразитьОплатаПлатежнымиКартами(ДополнительныеСвойства, Движения, Отказ);
	// Заказы покупателей в розничной торговле
	УправлениеНебольшойФирмойСервер.ОтразитьЗаказыПокупателей(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьПлатежныйКалендарь(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьОплатаСчетовИЗаказов(ДополнительныеСвойства, Движения, Отказ);
	
	УправлениеНебольшойФирмойСервер.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// СерийныеНомера
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераГарантии(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераОстатки(ДополнительныеСвойства, Движения, Отказ);
	
	// Подарочные сертификаты
	УправлениеНебольшойФирмойСервер.ОтразитьПодарочныеСертификаты(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьОплатаПодарочнымиСертификатами(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРасчетыСПокупателями(ДополнительныеСвойства, Движения, Отказ);
	
	// Бонусы
	УправлениеНебольшойФирмойСервер.ОтразитьБонусныеБаллы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьНачисленияБонусныхБаллов(ДополнительныеСвойства, Движения, Отказ);
	
	АссистентУправленияПриСрабатыванииСобытия();
	
	// Акцизные марки
	УправлениеНебольшойФирмойСервер.ОтразитьОстаткиАлкогольнойПродукцииЕГАИС(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.ЧекККМВозврат.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.ЧекККМВозврат.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли