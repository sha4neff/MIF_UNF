
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НавигационнаяСсылка = "e1cib/app/" + ЭтотОбъект.ИмяФормы;
	Элементы.СписокОрганизация.Видимость = ЭлектронноеВзаимодействиеСлужебный.ИспользуетсяНесколькоОрганизаций();
	
	ВыполнитьДлительнуюОперацию();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОжидатьДлительнуюОперацию();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьПредупреждение(, НСтр("ru = 'В форме отображается список внешних публикаций с возможностью удаления в сервисе 1С:Торговая площадка
		|Просмотр информации о внешней публикации торговых предложений возможен только
		|в программе (приложении), из которой производится публикация.'"),,
		НСтр("ru = 'Внешняя публикация торговых предложений'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалитьПубликацию(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбраны строки для выполнения команды'"));
		Возврат;
	КонецЕсли;
	
	УдалитьПубликациюПродолжение = Новый ОписаниеОповещения("УдалитьПубликациюПродолжение", ЭтотОбъект);
	ПоказатьВопрос(УдалитьПубликациюПродолжение,
		НСтр("ru = 'Выбранные публикации будут удалены в сервисе 1С:Торговая площадка.
			|Операция необратима. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
		
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОчиститьСообщения();
	ВыполнитьДлительнуюОперацию();
	ОжидатьДлительнуюОперацию();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыполнитьДлительнуюОперацию(СледующаяСтраница = Ложь)
	
	Задание = Новый Структура("ИмяПроцедуры, Наименование, ПараметрыПроцедуры");
	Задание.Наименование = НСтр("ru = '1С:Торговая площадка. Получение внешних публикаций.'");
	Задание.ИмяПроцедуры = "ТорговыеПредложенияСлужебный.ПолучитьВнешниеПрайсЛисты";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Задание.Наименование;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0.2;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(Задание.ИмяПроцедуры,
		Задание.ПараметрыПроцедуры, ПараметрыВыполнения);
		
	ПриИзмененииДлительнойОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьДлительнуюОперацию()
	
	Если ДлительнаяОперация <> Неопределено И ДлительнаяОперация.Статус = "Выполняется" Тогда
	
		// Инициализация обработчика ожидания завершения длительной операции.
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Получение внешних публикаций.'");
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
		ПараметрыОжидания.ВыводитьСообщения = Истина;
		ПараметрыОжидания.Вставить("ИдентификаторЗадания", ДлительнаяОперация.ИдентификаторЗадания);
		ПараметрыОжидания.Интервал = 1;
		ОбработкаЗавершенияПоиска = Новый ОписаниеОповещения("ПолучитьВнешниеПрайсЛистыЗавершение",
			ЭтотОбъект, ДлительнаяОперация);
			
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОбработкаЗавершенияПоиска, ПараметрыОжидания);
		
	Иначе
		
		ПолучитьВнешниеПрайсЛистыЗавершение(ДлительнаяОперация, ДлительнаяОперация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВнешниеПрайсЛистыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	// Вывод сообщений из фонового задания.
	Отказ = Ложь;
	ТорговыеПредложенияКлиент.ОбработатьОшибкиФоновогоЗадания(Результат, Отказ);
	
	Если Результат <> Неопределено И Результат.Статус = "Выполнено" Тогда
		ПолучитьВнешниеПрайсЛистыЗагрузка(Результат.АдресРезультата);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьВнешниеПрайсЛистыЗагрузка(АдресРезультата)
	
	Результат = БизнесСеть.ПолучитьУдалитьИзВременногоХранилища(АдресРезультата);
	
	Если Результат <> Неопределено Тогда
		СписокЗначение = РеквизитФормыВЗначение("Список");
		СписокЗначение.Очистить();
		Для каждого ЭлементКоллекции Из Результат Цикл
			ЗаполнитьЗначенияСвойств(СписокЗначение.Добавить(), ЭлементКоллекции);
		КонецЦикла;
		ЗначениеВРеквизитФормы(СписокЗначение, "Список");
	КонецЕсли;
	
	ДлительнаяОперация = Неопределено;
	ПриИзмененииДлительнойОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПубликациюПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	МассивИдентификаторов = Новый Массив;
	Для каждого ЭлементКоллекции Из Элементы.Список.ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Список.НайтиПоИдентификатору(ЭлементКоллекции);
		
		Идентификаторы = Новый Структура;
		
		Идентификаторы.Вставить("ИдентификаторПрайсЛиста",  ДанныеСтроки.Идентификатор);
		Идентификаторы.Вставить("ИдентификаторОрганизации", ДанныеСтроки.ИдентификаторОрганизации);
		
		МассивИдентификаторов.Добавить(Идентификаторы);
		
	КонецЦикла;
	
	Отказ = Ложь;
	УдалитьПубликациюНаСервере(МассивИдентификаторов, Отказ);
	Если Не Отказ Тогда
		ОжидатьДлительнуюОперацию();
	КонецЕсли;
	
	Оповестить("ТорговыеПредложения_ОбновлениеПубликаций");

КонецПроцедуры

&НаСервере
Процедура УдалитьПубликациюНаСервере(МассивИдентификаторов, Отказ)
	
	Для каждого ЭлементКоллекции Из МассивИдентификаторов Цикл
		
		ПараметрыЗапроса = ТорговыеПредложенияСлужебный.НовыеПараметрыПолученияПрайсЛистов(
			ЭлементКоллекции.ИдентификаторОрганизации, ЭлементКоллекции.ИдентификаторПрайсЛиста);
		ЗапросСервиса = ТорговыеПредложенияСлужебный.ЗапросСервисаУдалениеПрайсЛиста(ПараметрыЗапроса);
		ТорговыеПредложенияСлужебный.ВыполнитьЗапрос(ЗапросСервиса, Отказ);
		Если Отказ Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не Отказ Тогда
		ВыполнитьДлительнуюОперацию();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииДлительнойОперации()
	
	ОперацияВыполняется = ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Выполняется";
	
	Элементы.КомандаУдалитьПубликацию.Доступность = Не ОперацияВыполняется;
	
	Элементы.КомандаОбновить.Картинка = ?(ОперацияВыполняется, БиблиотекаКартинок.СинхронизацияДанныхДлительнаяОперация,
		БиблиотекаКартинок.Обновить);
	
КонецПроцедуры

#КонецОбласти
