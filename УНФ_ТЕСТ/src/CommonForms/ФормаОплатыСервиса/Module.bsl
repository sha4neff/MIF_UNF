
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ИдентификаторОбъекта = Параметры.ИдентификаторОбъекта;
	ИдентификаторПравила = Параметры.ИдентификаторПравила;
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание;
	
	СтруктураОплатТарифа = ОплатаСервисаУНФ.ПолучитьСтруктуруОплатТарифа();
	ЗаполнитьСпособыОплаты(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    ПодключитьОбработчикОжидания("ПолучитьДанныеПоОбъекту", 1, Истина);
    
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СсылкиНаФайлыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
    
    СтандартнаяОбработка = Ложь;
    Файл = Файлы.НайтиПоИдентификатору(Число(НавигационнаяСсылкаФорматированнойСтроки));
    ПолучитьФайл(Файл.Адрес, Файл.Имя, Истина);
    
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьВыбранныйТариф(Команда)
	ОплатаСервисаУНФКлиент.ОбработатьКомандуОплаты(СпособОплаты, СчетПоставщика, ПечатнаяФормаСчетаПоставщика, Абонент);
КонецПроцедуры

&НаКлиенте
Процедура СпособОплатыПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	СтруктураВариантаОплаты = Форма.СтруктураОплатТарифа[Форма.СпособОплаты];
	Элементы.ОплатитьВыбранныйТариф.Заголовок = СтруктураВариантаОплаты.НазваниеКоманды;
	Элементы.ОплатаКомментарии.Заголовок = СтруктураВариантаОплаты.ОплатаКомментарии;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСпособыОплаты(Форма)
	
	СписокВыбора = Форма.Элементы.СпособОплаты.СписокВыбора;
	
	СписокВыбора.Очистить();
	
	Для Каждого ВариантОплаты Из Форма.СтруктураОплатТарифа Цикл
		Если Не ЗначениеЗаполнено(Форма.СчетПоставщика) И (ВариантОплаты.Ключ <> "ОплатаНаличными") Тогда
			Продолжить;
		КонецЕсли;
		СписокВыбора.Добавить(ВариантОплаты.Ключ, ВариантОплаты.Значение.Представление);
	КонецЦикла;
	
	Форма.СпособОплаты = СписокВыбора[0].Значение;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФайлыПоДаннымХранилища(ДанныеХранилища)
	Результат = Новый Структура("Ссылка, ИдентификаторСчетаПокупателю, ИдентификаторСчетаПоставщика, ПлатежнаяСсылка, Сообщение");
	Для Каждого Файл Из ДанныеХранилища[ПолеФайлы()] Цикл
		УстановитьПривилегированныйРежим(Истина);
		ИмяФайла = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(Файл[ПолеИдентификаторФайла()]);
		УстановитьПривилегированныйРежим(Ложь);
		ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
		АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла, УникальныйИдентификатор);
		
		МассивЧастейИмениФайла = СтрРазделить(Файл.name, ".");
		РасширениеФайла = МассивЧастейИмениФайла[МассивЧастейИмениФайла.ВГраница()];
		
		Если РасширениеФайла = "zip" Тогда
			АдресаФайловXML = Новый Массив;
			АдресаФайловXML.Добавить(АдресФайла);
			
			ДанныеДокументов = ОплатаСервисаУНФ.ДанныеДокументов(АдресаФайловXML);
			
			РеквизитыКонтрагента = ДанныеДокументов[0].ДанныеДокумента.РеквизитыКонтрагента;
			Контрагент = ОплатаСервисаУНФ.СоздатьКонтрагента(РеквизитыКонтрагента);
			
			
			Товары     = ДанныеДокументов[0].ДанныеДокумента.Товары;
			НомерСчета = ДанныеДокументов[0].НомерСчета;
			ДатаСчета  = ДанныеДокументов[0].ДатаСчета;
			
			Результат.Ссылка = ОплатаСервисаУНФ.СоздатьСчетНаОплатуПоставщика(ДанныеДокументов[0].ИННОрганизации, Контрагент, Товары, НомерСчета, ДатаСчета, ДанныеДокументов[0].ЦенаВключаетНДС);
			Результат.ИдентификаторСчетаПокупателю = ДанныеДокументов[0].ДанныеДокумента.ИдентификаторДокумента;
			Результат.ИдентификаторСчетаПоставщика = Результат.Ссылка.УникальныйИдентификатор();
		КонецЕсли;
	КонецЦикла;
	
	Если Контрагент = Неопределено Тогда
		// Может быть не заполнен счет, если организации нет в справочнике Организаций
		// Но должен быть создан контрагент
		ВызватьИсключение НСтр("ru='Не обнаружен электронный счет на оплату (zip)'");
	КонецЕсли;
	
	Для Каждого Файл Из ДанныеХранилища[ПолеФайлы()] Цикл
		
		ИмяФайла = Файл[ПолеИмяФайла()];
		УстановитьПривилегированныйРежим(Истина);
		ИмяВременногоФайла = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(Файл[ПолеИдентификаторФайла()]);
		
		
		ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяВременногоФайла);
		АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
		
		
		УстановитьПривилегированныйРежим(Ложь);
		
		Попытка
			УдалитьФайлы(ИмяВременногоФайла);
		Исключение
			Комментарий = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(КорневоеСобытие(), УровеньЖурналаРегистрации.Ошибка, , , Комментарий);
		КонецПопытки;
		
		РасширениеФайла = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла);
		РасширениеБезТочки = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РасширениеФайла);
		ИмяФайлаБезРасширения = Лев(ИмяФайла, СтрДлина(ИмяФайла) - СтрДлина(РасширениеФайла));
		
		Если ЗначениеЗаполнено(Результат.Ссылка) Тогда
			ВладелецФайлов = Результат.Ссылка;
		Иначе
			ВладелецФайлов = Контрагент;
		КонецЕсли;
		ПараметрыФайла = Новый Структура;
		ПараметрыФайла.Вставить("Автор", Пользователи.АвторизованныйПользователь());
		ПараметрыФайла.Вставить("ИмяБезРасширения", ИмяФайлаБезРасширения);
		ПараметрыФайла.Вставить("РасширениеБезТочки", РасширениеБезТочки);
		ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное");
		ПараметрыФайла.Вставить("ВладелецФайлов", ВладелецФайлов);
		РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресФайла);
		
		ПечатнаяФормаСчетаПоставщика = ОплатаСервисаУНФВызовСервера.ПолучитьПрисоединенныйТабличныйДокумент(ВладелецФайлов, ИмяФайлаБезРасширения);
	КонецЦикла;
	СчетПоставщика = Результат.Ссылка;
	
	Если ЗначениеЗаполнено(СчетПоставщика) Тогда
		Абонент =  ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СчетПоставщика, "Организация");
	КонецЕсли;
	
	ЗаполнитьСпособыОплаты(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция КорневоеСобытие()
    
    КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Универсальная интеграция'", КодЯзыка);
	
КонецФункции

&НаКлиенте
Процедура ПолучитьДанныеПоОбъекту()
	
    ПовторитьЗапрос = ПолучитьДанныеПоОбъектуНаСервере();
    Если ПовторитьЗапрос Тогда
        ПодключитьОбработчикОжидания("ПолучитьДанныеПоОбъекту", 1, Истина);
	Иначе
       
    КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеПоОбъектуНаСервере()
    
    ПолученныеДанныеОбъекта = УниверсальнаяИнтеграция.ПрочитатьПолученныеДанныеОбъекта(ИдентификаторПравила, ИдентификаторОбъекта);
    Если ТипЗнч(ПолученныеДанныеОбъекта) = Тип("Структура") Тогда
        Если ПолученныеДанныеОбъекта.Свойство(ПолеОшибкаОбработки()) И ПолученныеДанныеОбъекта[ПолеОшибкаОбработки()] Тогда
            Предупреждение = ПолученныеДанныеОбъекта[ПолеСообщениеОбОшибке()];
            Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка;
		ИначеЕсли ПолученныеДанныеОбъекта.Свойство(ПолеФайлы()) И ПолученныеДанныеОбъекта[ПолеФайлы()].Количество() > 0 Тогда
			Попытка
				ЗаполнитьФайлыПоДаннымХранилища(ПолученныеДанныеОбъекта);
			Исключение
				Предупреждение = ОписаниеОшибки();
				Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка;
				
				Возврат Ложь;
			КонецПопытки;
			Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат;
        Иначе
            Возврат Истина;
        КонецЕсли;
        УниверсальнаяИнтеграция.ОтписатьсяОтОповещенийНаИзменения(ИдентификаторПравила, Строка(ИдентификаторОбъекта));
        Возврат Ложь;
    Иначе
        Возврат Истина;
    КонецЕсли; 
	
КонецФункции

&НаСервере
Функция ПолеИдентификаторФайла()
	
	Возврат "id";
	
КонецФункции
 
&НаСервере
Функция ПолеИмяФайла()
	
	Возврат "name";
	
КонецФункции

&НаСервере
Функция ПолеОшибкаОбработки()
	
	Возврат "error";
	
КонецФункции

&НаСервере
Функция ПолеСообщениеОбОшибке()
	
	Возврат "message";
	
КонецФункции

&НаСервере
Функция ПолеФайлы()
	
	Возврат "files";
	
КонецФункции

#КонецОбласти 
