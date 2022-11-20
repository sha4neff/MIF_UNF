
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.Год = Макс(2017, Год(ТекущаяДатаСеанса()) - 1);
		ЗаполнитьОтчетныйПериод(ЭтаФорма);
		Объект.ТипСведений = Перечисления.ТипыСведенийСЗВ_СТАЖ.Исходная;
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьДоступностьДанныхФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "РедактированиеДанныхСтажаПоСотруднику" И Источник.ВладелецФормы = ЭтаФорма Тогда
		ПриИзмененииДанныхДокументаПоСотруднику(Параметр.АдресВоВременномХранилище);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект", Тип("ДокументОбъект.СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ"));
	
	Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда 
		Отказ = Истина;
	КонецЕсли;	
	
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();	
	
КонецПроцедуры

&НаКлиенте
Процедура ГодПриИзменении(Элемент)
	
	ЗаполнитьОтчетныйПериод(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСведенийПриИзменении(Элемент)
	
	ТипСведенийПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагБлокировкиДокументаПриИзменении(Элемент)
	
	ФлагБлокировкиДокументаПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыСотрудники

&НаКлиенте
Процедура СотрудникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Объект.ТипСведений = ПредопределенноеЗначение("Перечисление.ТипыСведенийСЗВ_СТАЖ.НазначениеПенсии") Тогда 
		Элемент.ТекущиеДанные.ДатаВыходаНаПенсию = Объект.Дата;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	
	СотрудникиПередУдалениемНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СотрудникиДатаВыходаНаПенсию" Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Сотрудник) Тогда
		Возврат;
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуРедактированияКарточкиДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
	
	СписокСотрудников = Новый Массив;
	Для Каждого Сотрудник Из ВыбранноеЗначение Цикл
		СписокСотрудников.Добавить(Сотрудник);
	КонецЦикла;
	
	ЗаполнитьДанныеСотрудников(СписокСотрудников);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Сотрудник) Тогда 
		Возврат;
	КонецЕсли;
	
	СотрудникиПриОкончанииРедактированияНаСервере(ТекущиеДанные.Сотрудник);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	СотрудникиСотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиДатаВыходаНаПенсиюПриИзменении(Элемент)
	
	СотрудникиДатаВыходаНаПенсиюПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Оповещение = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуЗавершение", ЭтотОбъект, Команда);
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключаемуюКомандуЗавершение(Результат, Команда) Экспорт
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьДокументНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	
	ПараметрыОткрытияФормы = Новый Структура;
	СтруктураОтбора = Новый Структура;
	Если Не УправлениеНебольшойФирмойВызовСервера.ПолучитьКонстантуСервер("УчетПоКомпании") Тогда
		СтруктураОтбора.Вставить("Организация", Объект.Организация);
	КонецЕсли;
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Истина);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыОткрытияФормы.Вставить("Отбор", СтруктураОтбора);
	ПараметрыОткрытияФормы.Вставить("АдресСпискаПодобранныхСотрудников", АдресСпискаПодобранныхСотрудников());
	
	ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаВыбора", ПараметрыОткрытияФормы, Элементы.Сотрудники);
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ОчиститьСообщения();

	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);
	Если Отказ Тогда
		ТекстСообщения = НСтр("ru = 'При проверке встроенной проверкой обнаружены ошибки.'")
	Иначе	
		ТекстСообщения = НСтр("ru = 'При проверке встроенной проверкой ошибок не обнаружено.'");
	КонецЕсли;
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтаФорма, "ПФР");	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВПФР(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОтправитьВКонтролирующийОрганЗавершение", ЭтотОбъект);	
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрганЗавершение(Результат, Параметры) Экспорт
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтаФорма, "ПФР");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаДиск(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьНаДискЗавершение", ЭтотОбъект);	
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);			
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаДискЗавершение(Результат, Параметры) Экспорт
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ФлагБлокировкиДокумента = Объект.ДокументПринятВПФР;	
	УстановитьДоступностьДанныхФормы();
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьДанныхФормы()
	
	Если Объект.ДокументПринятВПФР Тогда  
		ТолькоПросмотр = Истина;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементовФормы()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"СтраницаДосрочноеНазначениеПенсии", 
		"Доступность", Объект.ТипСведений = Перечисления.ТипыСведенийСЗВ_СТАЖ.Исходная);
			
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"Страницы", 
		"ОтображениеСтраниц", 
		 ОтображениеСтраницФормы.ЗакладкиСверху);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"НачисленыВзносыНаОПС", 
		"Доступность", 
		Объект.ТипСведений = Перечисления.ТипыСведенийСЗВ_СТАЖ.НазначениеПенсии); 
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"НачисленыВзносыПоДТ", 
		"Доступность", 
		Объект.ТипСведений = Перечисления.ТипыСведенийСЗВ_СТАЖ.НазначениеПенсии);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"СотрудникиДатаВыходаНаПенсию", 
		"Видимость", 
		Объект.ТипСведений = Перечисления.ТипыСведенийСЗВ_СТАЖ.НазначениеПенсии);
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументНаСервере()
	
	Объект.Сотрудники.Очистить();
	Объект.ЗаписиОСтаже.Очистить();
	Объект.ДосрочноеНазначениеПенсии.Очистить();
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Документы.СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ.СоздатьВТПерсональныеДанныеСотрудников(МенеджерВременныхТаблиц, Объект.Организация, Объект.Год);
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПерсональныеДанные.Сотрудник,
	               |	ПерсональныеДанные.Фамилия,
	               |	ПерсональныеДанные.Имя,
	               |	ПерсональныеДанные.Отчество,
	               |	ПерсональныеДанные.СтраховойНомерПФР,
	               |	ПерсональныеДанные.СотрудникУволен
	               |ИЗ
	               |	ВТПерсональныеДанныеСотрудников КАК ПерсональныеДанные";
								
	Выборка = Запрос.Выполнить().Выбрать();							
	
	СписокСотрудников = Новый Массив;
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Сотрудники.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		Если Объект.ТипСведений = Перечисления.ТипыСведенийСЗВ_СТАЖ.НазначениеПенсии Тогда 
			НоваяСтрока.ДатаВыходаНаПенсию = Объект.Дата;
		КонецЕсли;
		СписокСотрудников.Добавить(Выборка.Сотрудник);
	КонецЦикла;
	
	Документы.СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ.ЗаполнитьДанныеОСтажеСотрудников(Объект, СписокСотрудников);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСотрудников(СписокСотрудников)
	
	Год = ?(ЗначениеЗаполнено(Объект.Год), Объект.Год, Год(ТекущаяДатаСеанса()));
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Документы.СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ.СоздатьВТПерсональныеДанныеСотрудников(МенеджерВременныхТаблиц, Объект.Организация, Год, СписокСотрудников);
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПерсональныеДанные.Сотрудник,
	               |	ПерсональныеДанные.Фамилия,
	               |	ПерсональныеДанные.Имя,
	               |	ПерсональныеДанные.Отчество,
	               |	ПерсональныеДанные.СтраховойНомерПФР,
	               |	ПерсональныеДанные.СотрудникУволен
	               |ИЗ
	               |	ВТПерсональныеДанныеСотрудников КАК ПерсональныеДанные";
								
	Выборка = Запрос.Выполнить().Выбрать();							
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Сотрудники.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		Если Объект.ТипСведений = Перечисления.ТипыСведенийСЗВ_СТАЖ.НазначениеПенсии Тогда 
			НоваяСтрока.ДатаВыходаНаПенсию = Объект.Дата;
		КонецЕсли;
	КонецЦикла;
	
	Документы.СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ.ЗаполнитьДанныеОСтажеСотрудников(Объект, СписокСотрудников);
	ЗаполнитьДанныеОФактеНачисленияВзносов();
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиСотрудникПриИзмененииНаСервере()
	
	СтрокаСотрудника = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	Год = ?(ЗначениеЗаполнено(Объект.Год), Объект.Год, Год(ТекущаяДатаСеанса()));
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Документы.СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ.СоздатьВТПерсональныеДанныеСотрудников(МенеджерВременныхТаблиц, Объект.Организация, Год, СтрокаСотрудника.Сотрудник);
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПерсональныеДанные.Сотрудник,
	               |	ПерсональныеДанные.Фамилия,
	               |	ПерсональныеДанные.Имя,
	               |	ПерсональныеДанные.Отчество,
	               |	ПерсональныеДанные.СтраховойНомерПФР,
	               |	ПерсональныеДанные.СотрудникУволен
	               |ИЗ
	               |	ВТПерсональныеДанныеСотрудников КАК ПерсональныеДанные";
								
	Выборка = Запрос.Выполнить().Выбрать();							
	
	СтруктураПоиска = Новый Структура("Сотрудник");
	
	Пока Выборка.Следующий() Цикл
		СтруктураПоиска.Сотрудник = Выборка.Сотрудник;
		НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСтроки.Количество() <> 0 Тогда 
			СтрокаСотрудника = НайденныеСтроки[0];
			ЗаполнитьЗначенияСвойств(СтрокаСотрудника, Выборка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Процедура СотрудникиДатаВыходаНаПенсиюПриИзмененииНаСервере()
	
	ПерсонифицированныйУчетКлиентСервер.ДокументыРедактированияСтажаСотрудникиПередУдалением(Элементы.Сотрудники.ВыделенныеСтроки, Объект.Сотрудники, Объект.ЗаписиОСтаже);
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиПриОкончанииРедактированияНаСервере(Сотрудник)
	
	ДанныеОСтаже = Объект.ЗаписиОСтаже.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	Если ДанныеОСтаже.Количество() > 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Документы.СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ.ЗаполнитьДанныеОСтажеСотрудников(Объект, Сотрудник);
	ЗаполнитьДанныеОФактеНачисленияВзносов();
	
КонецПроцедуры




&НаСервере
Процедура ЗаполнитьДанныеОФактеНачисленияВзносов(УдаляемыеСтроки = Неопределено)
	
	Если Объект.ТипСведений <> Перечисления.ТипыСведенийСЗВ_СТАЖ.НазначениеПенсии Тогда 
		Объект.НачисленыВзносыНаОПС = Ложь;
		Объект.НачисленыВзносыПоДТ = Ложь;
		Возврат;
	КонецЕсли;
	
	УдаляемыеСотрудники = Новый Соответствие;
	Если УдаляемыеСтроки <> Неопределено Тогда 
		Для Каждого Идентификатор Из УдаляемыеСтроки Цикл
			СтрокаСотрудника = Объект.Сотрудники.НайтиПоИдентификатору(Идентификатор);
			Если СтрокаСотрудника <> Неопределено Тогда
				УдаляемыеСотрудники.Вставить(СтрокаСотрудника.Сотрудник, Истина);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("ФизическоеЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаСотрудников.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	ДатаАктуальности = Объект.Дата;
	Если Не ЗначениеЗаполнено(ДатаАктуальности) Тогда
		ДатаАктуальности = ТекущаяДатаСеанса();
	КонецЕсли;	
	
	Для Каждого СтрокаКоллекции Из Объект.Сотрудники Цикл
		Если УдаляемыеСтроки <> Неопределено И УдаляемыеСотрудники[СтрокаКоллекции.Сотрудник] <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		СтрокаТаблицы = ТаблицаСотрудников.Добавить();
		СтрокаТаблицы.ФизическоеЛицо = СтрокаКоллекции.Сотрудник;
		СтрокаТаблицы.Период = Макс(ДатаАктуальности, СтрокаКоллекции.ДатаВыходаНаПенсию);
	КонецЦикла;
	
	Если ТаблицаСотрудников.Количество() = 0 Тогда 
		Объект.НачисленыВзносыНаОПС = Ложь;
		Объект.НачисленыВзносыПоДТ = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ТаблицаСотрудников", ТаблицаСотрудников);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаСотрудников.ФизическоеЛицо,
	               |	ТаблицаСотрудников.Период
	               |ПОМЕСТИТЬ ВТФизическиеЛица
	               |ИЗ
	               |	&ТаблицаСотрудников КАК ТаблицаСотрудников";
	
	Запрос.Выполнить();
	
	ОтчетныйПериод = ?(ЗначениеЗаполнено(Объект.Год), Дата(Объект.Год, 1, 1), НачалоГода(ТекущаяДатаСеанса()));
	
	УстановитьПривилегированныйРежим(Истина);
	УчетСтраховыхВзносов.СформироватьВТДанныеОФактеНачисленияВзносовВПФР(
		Запрос.МенеджерВременныхТаблиц,
		Объект.Организация,
		ОтчетныйПериод,
		КонецГода(ОтчетныйПериод));
	УстановитьПривилегированныйРежим(Ложь);
		
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ИСТИНА КАК ЗначениеИстина
	               |ИЗ
	               |	ВТДанныеОФактеНачисленияВзносов КАК ДанныеОФактеНачисленияВзносов
	               |ГДЕ
	               |	ДанныеОФактеНачисленияВзносов.НачисленоНаОПС
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ИСТИНА КАК ЗначениеИстина
	               |ИЗ
	               |	ВТДанныеОФактеНачисленияВзносов КАК ДанныеОФактеНачисленияВзносов
	               |ГДЕ
	               |	ДанныеОФактеНачисленияВзносов.НачисленоПоДополнительнымТарифам";
				   
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Объект.НачисленыВзносыНаОПС = Не РезультатыЗапроса[0].Пустой();	
	Объект.НачисленыВзносыПоДТ = Не РезультатыЗапроса[1].Пустой();	
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.Сотрудники.Очистить();
	Объект.ЗаписиОСтаже.Очистить();
	Объект.ДосрочноеНазначениеПенсии.Очистить();
	
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ТипСведенийПриИзмененииНаСервере()
	
	УстановитьСвойстваЭлементовФормы();
	ЗаполнитьДатуНазначенияПенсии();
	ЗаполнитьДанныеОФактеНачисленияВзносов();
	
	Объект.ЗаписиОСтаже.Очистить();
	Документы.СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ.ЗаполнитьДанныеОСтажеСотрудников(Объект, ОбщегоНазначения.ВыгрузитьКолонку(Объект.Сотрудники, "Сотрудник"));
	
КонецПроцедуры

&НаСервере
Процедура ФлагБлокировкиДокументаПриИзмененииНаСервере()
	
	Модифицированность = Истина;
	Объект.ДокументПринятВПФР = ФлагБлокировкиДокумента;
	Если Не ФлагБлокировкиДокумента Тогда
		ТолькоПросмотр = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиПередУдалениемНаСервере()
	
	ПерсонифицированныйУчетКлиентСервер.ДокументыРедактированияСтажаСотрудникиПередУдалением(Элементы.Сотрудники.ВыделенныеСтроки, Объект.Сотрудники, Объект.ЗаписиОСтаже);
	ЗаполнитьДанныеОФактеНачисленияВзносов(Элементы.Сотрудники.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьОтчетныйПериод(Форма)
	
	Объект = Форма.Объект;
	Если Не ЗначениеЗаполнено(Объект.Год) Тогда 
		Возврат;
	КонецЕсли;
	
	Объект.ОтчетныйПериод = Дата(Объект.Год, 1, 1);
	Объект.ОкончаниеОтчетногоПериода = КонецГода(Объект.ОтчетныйПериод);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДатуНазначенияПенсии()
	
	Если Объект.ТипСведений <> Перечисления.ТипыСведенийСЗВ_СТАЖ.НазначениеПенсии Тогда 
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаСотрудника Из Объект.Сотрудники Цикл 
		СтрокаСотрудника.ДатаВыходаНаПенсию = Объект.Дата;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияКарточкиДокумента()
	
	ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
	ДанныеШапкиТекущегоДокумента = Объект;
	
	Если ДанныеТекущейСтроки <> Неопределено Тогда	
		
		ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище();
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("АдресВоВременномХранилище", АдресДанныхТекущегоДокументаВХранилище);
		ПараметрыОткрытияФормы.Вставить("РедактируемыйДокументСсылка", ДанныеШапкиТекущегоДокумента.Ссылка);
		ПараметрыОткрытияФормы.Вставить("Сотрудник", ДанныеТекущейСтроки.Сотрудник);
		ПараметрыОткрытияФормы.Вставить("ДатаВыходаНаПенсию", ДанныеТекущейСтроки.ДатаВыходаНаПенсию);
		ПараметрыОткрытияФормы.Вставить("Организация", ДанныеШапкиТекущегоДокумента.Организация);
		ПараметрыОткрытияФормы.Вставить("Год", Объект.Год);
		ПараметрыОткрытияФормы.Вставить("ИсходныйНомерСтроки", 0);
		ПараметрыОткрытияФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		ПараметрыОткрытияФормы.Вставить("НеОтображатьОшибки", Истина);
		
		ОткрытьФорму("Документ.СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ.Форма.ФормаРедактированияСтажа", ПараметрыОткрытияФормы, ЭтаФорма);	
		
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище()
	
	Если Элементы.Сотрудники.ТекущаяСтрока = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;	
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;
	
	ДанныеСотрудника = Новый Структура;
	ДанныеСотрудника.Вставить("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	ДанныеСотрудника.Вставить("СтраховойНомерПФР", ДанныеТекущейСтрокиПоСотруднику.СтраховойНомерПФР);
	ДанныеСотрудника.Вставить("Фамилия", ДанныеТекущейСтрокиПоСотруднику.Фамилия);
	ДанныеСотрудника.Вставить("Имя", ДанныеТекущейСтрокиПоСотруднику.Имя);
	ДанныеСотрудника.Вставить("Отчество", ДанныеТекущейСтрокиПоСотруднику.Отчество);
	ДанныеСотрудника.Вставить("СотрудникУволен", ДанныеТекущейСтрокиПоСотруднику.СотрудникУволен);
	ДанныеСотрудника.Вставить("ФиксСтаж", ДанныеТекущейСтрокиПоСотруднику.ФиксСтаж);
    ДанныеСотрудника.Вставить("ЗаписиОСтаже", Новый Массив);
	ДанныеСотрудника.Вставить("ИсходныйНомерСтроки", ДанныеТекущейСтрокиПоСотруднику.ИсходныйНомерСтроки);
	
	ЗначенияРеквизитовХраненияОшибок = ПерсонифицированныйУчетКлиентСервер.ЗначенияРеквизитовХраненияОшибокВСтруктуру(
											ЭтаФорма, 
											ДанныеТекущейСтрокиПоСотруднику,
											"Объект.Сотрудники");
											
	ДанныеСотрудника.Вставить("ЗначенияРеквизитовХраненияОшибок", ЗначенияРеквизитовХраненияОшибок);	
	
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	
	СтрокиЗаписиОСтаже = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаСтаж Из СтрокиЗаписиОСтаже Цикл
		СтруктураПолейЗаписиОСтаже = СтруктураПолейЗаписиОСтаже();
		ЗаполнитьЗначенияСвойств(СтруктураПолейЗаписиОСтаже, СтрокаСтаж);
		СтруктураПолейЗаписиОСтаже.ИдентификаторИсходнойСтроки = СтрокаСтаж.ПолучитьИдентификатор(); 
		
		ЗначенияРеквизитовХраненияОшибок = ПерсонифицированныйУчетКлиентСервер.ЗначенияРеквизитовХраненияОшибокВСтруктуру(
												ЭтаФорма, 
												СтрокаСтаж,
												"Объект.ЗаписиОСтаже");	
		
		ДанныеСотрудника.ЗаписиОСтаже.Добавить(СтруктураПолейЗаписиОСтаже);
	КонецЦикла;	
	
	Если ЗначениеЗаполнено(АдресДанныхТекущегоДокументаВХранилище) Тогда
		ПоместитьВоВременноеХранилище(ДанныеСотрудника, АдресДанныхТекущегоДокументаВХранилище);	
	Иначе	
		АдресДанныхТекущегоДокументаВХранилище = ПоместитьВоВременноеХранилище(ДанныеСотрудника, УникальныйИдентификатор);
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция СтруктураПолейЗаписиОСтаже()
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("НомерОсновнойЗаписи");
	СтруктураПолей.Вставить("НомерДополнительнойЗаписи");
	СтруктураПолей.Вставить("ДатаНачалаПериода");
	СтруктураПолей.Вставить("ДатаОкончанияПериода");
	СтруктураПолей.Вставить("ОсобыеУсловияТруда");
	СтруктураПолей.Вставить("КодПозицииСписка");
	СтруктураПолей.Вставить("ОснованиеИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ПервыйПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ВторойПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ТретийПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ОснованиеВыслугиЛет");
	СтруктураПолей.Вставить("ПервыйПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ВторойПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТретийПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТерриториальныеУсловия");
	СтруктураПолей.Вставить("ПараметрТерриториальныхУсловий");
	СтруктураПолей.Вставить("ЗамещениеГосударственныхМуниципальныхДолжностей");
	СтруктураПолей.Вставить("ИдентификаторИсходнойСтроки");

	Возврат СтруктураПолей;
	
КонецФункции

&НаСервере
Функция ОписаниеЭлементовСИндикациейОшибок() Экспорт
	ОписаниеЭлементовИндикацииОшибок = Новый Соответствие;	
	Возврат ОписаниеЭлементовИндикацииОшибок;
КонецФункции	

&НаКлиенте
Процедура ПриИзмененииДанныхДокументаПоСотруднику(АдресВоВременномХранилище)
	
	ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище);
	
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище)
	
	ДанныеШапкиДокумента = Объект;
	
	ДанныеТекущегоДокумента = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Если ДанныеТекущегоДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Неопределено;
	НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", ДанныеТекущегоДокумента.Сотрудник));
		
	Если НайденныеСтроки.Количество() > 0 Тогда
		ДанныеТекущейСтрокиПоСотруднику = НайденныеСтроки[0];
		Если ДанныеТекущейСтрокиПоСотруднику.Сотрудник <> ДанныеТекущегоДокумента.Сотрудник Тогда
			ДанныеТекущейСтрокиПоСотруднику = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено  Тогда
		ВызватьИсключение НСтр("ru = 'В текущем документе не найдены данные по редактируемому сотруднику.'");
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	ЗаполнитьЗначенияСвойств(ДанныеТекущейСтрокиПоСотруднику, ДанныеТекущегоДокумента);
		
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	
	СтрокиСтажа = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаСтажСотрудника Из СтрокиСтажа Цикл
		Объект.ЗаписиОСтаже.Удалить(Объект.ЗаписиОСтаже.Индекс(СтрокаСтажСотрудника));
	КонецЦикла;
	
	СтрокиСтажаПоСотруднику = Новый Массив;
	Для Каждого СтрокаСтаж Из ДанныеТекущегоДокумента.ЗаписиОСтаже Цикл
		СтрокаСтажОбъекта = Объект.ЗаписиОСтаже.Добавить();
		СтрокаСтажОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
		ЗаполнитьЗначенияСвойств(СтрокаСтажОбъекта, СтрокаСтаж);
		СтрокиСтажаПоСотруднику.Добавить(СтрокаСтажОбъекта);
	КонецЦикла;
	
	ПерсонифицированныйУчетКлиентСервер.ВыполнитьНумерациюЗаписейОСтаже(СтрокиСтажаПоСотруднику);
		
	Если ДанныеТекущегоДокумента.Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПроверкаЗаполненияДокумента(Отказ = Ложь)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ПроверитьДанныеДокумента(Отказ);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействия(ОповещениеЗавершения = Неопределено)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);	
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Если Отказ Тогда 
		ТекстВопроса = НСтр("ru = 'В комплекте обнаружены ошибки.
							|Продолжить (не рекомендуется)?'");
							
		Оповещение = Новый ОписаниеОповещения("ПроверитьСЗапросомДальнейшегоДействияЗавершение", ЭтотОбъект, ДополнительныеПараметры);					
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Предупреждение.'"));
	Иначе 
		ПроверитьСЗапросомДальнейшегоДействияЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);				
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;			
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайлаНаСервере(Ссылка, УникальныйИдентификатор)
	
	Возврат УчетСтраховыхВзносов.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти
